shader_type canvas_item;
render_mode unshaded;

// сила смещения (настрой в инспекторе)
uniform float intensity : hint_range(0.0, 0.1, 0.001) = 0.03;

// скорость анимации (чем выше — тем быстрее движение)
uniform float speed : hint_range(0.0, 10.0, 0.1) = 3.0;

// экранная текстура
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

void fragment() {
    // вычисляем смещение на основе времени
    float shift = sin(TIME * speed) * intensity;

    // основной UV текущего пикселя
    vec2 uv = SCREEN_UV;

    // сдвигаем красный канал вправо/вниз
    float r = texture(screen_texture, uv + vec2( shift, 0.0 )).r;

    // зелёный остаётся по центру
    float g = texture(screen_texture, uv).g;

    // сдвигаем синий канал в противоположном направлении
    float b = texture(screen_texture, uv + vec2(-shift, 0.0)).b;

    // итоговый цвета
    COLOR = vec4(r, g, b, 1.0);
}
