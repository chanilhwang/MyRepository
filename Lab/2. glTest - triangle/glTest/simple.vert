#version 450

//quantifier
layout(location = 0) in vec4 vertexPosition;
layout(location = 1) in vec3 vertexColor;

out vec3 fColor;

void main()
{
	fColor = vertexColor;
	gl_Position = vertexPosition; // in-built 내장 변수 gl_Position에 좌표값 입력




	
}