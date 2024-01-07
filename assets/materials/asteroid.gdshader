shader_type spatial;

uniform vec3 scale = vec3(0.1, 0.5, 0.1);
uniform vec4 color: source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform sampler2D noise;


vec3 displace(vec3 vertex){
	vec2 tex_position = vertex.xz / 2.0 + 0.5;
	float height = texture(noise, tex_position).x;
	return height * scale;
}

vec3 calculate_normal(vec3 vertex, vec3 tangent, vec3 normal, vec3 displacement){
	float dx = 0.01;
	vec3 tangent_dx = vertex + tangent * dx;
	vec3 bitangent_dx = vertex + cross(normal, tangent) * dx;
	vec3 vertex_displaced = vertex + displacement;
	
	tangent_dx += displacement;
	bitangent_dx += displacement;
	
	vec3 modified_tangent = tangent_dx - vertex_displaced;
	vec3 modified_bitangent = bitangent_dx - vertex_displaced;
	vec3 modified_normal = cross(modified_tangent, modified_bitangent);
	
	return normalize(modified_normal);
}

void vertex() {
	vec3 displacement = displace(VERTEX);
	
	VERTEX += displacement;
	NORMAL = calculate_normal(VERTEX, TANGENT, NORMAL, displacement);
}

void fragment() {
	ALBEDO = color.xyz;
	METALLIC = 0.1;
	ROUGHNESS = 0.8;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
