// Transforms a 3D position vector v by a given 4x4 transformation matrix m.
vec3 transform_position(mat4 m, vec3 v)
{
	vec4 u = m * vec4(v, 1.0);
	return u.xyz / u.w;
}
