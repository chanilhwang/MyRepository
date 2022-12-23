#include "ColorTriangle.h"

ColorTriangle::ColorTriangle()
{
	setup();
}

void ColorTriangle::setup()
{
	const float vertexPosition[] = {
	-0.2f, -0.2f, 0.f,
	0.2f, -0.2f, 0.f,
	0.0f, 0.2f, 0.f
	};

	const float vertexColor[] = {
		1.f, 0.f, 0.f,
		0.f, 1.f, 0.f,
		0.f, 0.f, 1.f
	};

	//VAO ����
	glGenVertexArrays(1, &vaoHandle);
	glBindVertexArray(vaoHandle); // ���⿡ �۾��ҰŴ� activate �ǹ�

	//VBO ���� - ������
	glGenBuffers(1, &vboPosition);
	glBindBuffer(GL_ARRAY_BUFFER, vboPosition); // vbo �̿�
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertexPosition), vertexPosition, GL_STATIC_DRAW);
	glVertexAttribPointer(
		0, // attrib ��ȣ
		3, // # of data for each vertex
		GL_FLOAT, // data type
		GL_FALSE, // normalized
		0,
		0
	);
	glEnableVertexAttribArray(0);

	//VBO ���� - �÷�
	glGenBuffers(1, &vboColor);
	glBindBuffer(GL_ARRAY_BUFFER, vboColor);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertexColor), vertexColor, GL_STATIC_DRAW);
	glVertexAttribPointer(
		1,
		3,
		GL_FLOAT,
		GL_FALSE,
		0,
		0
	);
	glEnableVertexAttribArray(1);

	glBindVertexArray(0); // VAO�� close
}

void ColorTriangle::draw()
{
	glBindVertexArray(vaoHandle);

	//normal draw
	glDrawArrays(GL_TRIANGLES, 0, 3);
}
