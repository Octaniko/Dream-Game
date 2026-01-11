shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

// blur
uniform float blur_radius : hint_range(0.0, 20.0) = 6.0;

// сколько пятен
uniform int num_blobs : hint_range(1, 15) = 6;

// скорость движения
uniform float move_speed : hint_range(0.0, 3.0) = 0.4;

// размер области blur (0.0…1.0)
uniform float blob_size : hint_range(0.0, 0.5) = 0.18;

// псевдохеш
float hash1(float x) {
    return fract(sin(x * 127.1) * 43758.5453123);
}
float hash2(float x) {
    return fract(sin(x * 311.7) * 96321.7531234);
}

// плавно вытягиваем координату для каждого пятна
vec2 blob_base(int idx) {
    float fi = float(idx) * 12.3456; // просто смешиваем индекс
    return vec2(hash1(fi), hash2(fi + 0.5));
}

// плавное движение
vec2 get_blob_pos(int idx, float t) {
    vec2 base = blob_base(idx);

    // направление движения — псевдорнд
    float ang = hash1(base.x + base.y + 1.234) * 6.28318;
    vec2 dir = vec2(cos(ang), sin(ang));

    // синус для плавности
    vec2 shift = sin(dir * (t * move_speed)) * 0.35;

    return clamp(base + shift, vec2(0.0), vec2(1.0));
}

// blur экранного пикселя
vec4 blur_screen(sampler2D tex, vec2 uv, float r) {
    vec4 c = vec4(0.0);
    float w = 0.0;
    ivec2 sz = textureSize(tex, 0);

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 off = vec2(float(x), float(y)) * (r / vec2(sz));
            c += texture(tex, uv + off);
            w += 1.0;
        }
    }
    return c / w;
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / vec2(textureSize(screen_texture, 0));
    float mask = 0.0;

    for (int i = 0; i < num_blobs; i++) {
        vec2 p = get_blob_pos(i, TIME);
        float d = distance(uv, p);
        mask += smoothstep(blob_size, blob_size * 0.5, d);
    }
    mask = clamp(mask, 0.0, 1.0);

    vec4 orig = texture(screen_texture, uv);
    vec4 bl = blur_screen(screen_texture, uv, blur_radius);

    COLOR = mix(orig, bl, mask);
}
