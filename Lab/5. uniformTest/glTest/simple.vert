#version 450

//quantifier
layout(location = 0) in vec4 vertexPosition;
layout(location = 1) in vec3 vertexColor;

uniform mat4 model;
out vec3 fColor;

void main()
{
	fColor = vertexColor;
	gl_Position = model * vertexPosition; // in-built ���� ���� gl_Position�� ��ǥ�� �Է�
	
}