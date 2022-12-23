#include "MyGlWindow.h"

MyGlWindow::MyGlWindow(int w, int h) : m_width(w), m_height(h)
{
	setupBuffer();
}

ShaderProgram* shaderProgram;
GLuint vaoHandle; // VAO handler
GLuint vboPosition; // VBO handler
GLuint vboColor;
GLuint ibo_cube_elements;

void MyGlWindow::setupBuffer() 
{
	shaderProgram = new ShaderProgram(); // ���̴� ������Ʈ ����
	shaderProgram->initFromFiles("simple.vert", "simple.frag");


	const float cube_vertices[] = {
		//front
		-0.5f, -0.5f, 0.5f,
		0.5f, -0.5f, 0.5f,
		0.5f, 0.5f, 0.5f,
		-0.5f, 0.5f, 0.5f,
		//back
		-0.5f, -0.5f, -0.5f,
		0.5f, -0.5f, -0.5f,
		0.5f, 0.5f, -0.5f,
		-0.5f, 0.5f, -0.5f
	};

	const float cube_colors[] = {
		//front
		1.f, 0.f, 0.f,
		0.f, 1.f, 0.f,
		0.f, 0.f, 0.f,
		1.f, 1.f, 1.f,
		//back
		1.f, 0.f, 0.f,
		0.f, 1.f, 0.f,
		0.f, 0.f, 1.f,
		1.f, 1.f, 1.f
	};

	const short cube_elements[] = {
		0,1,2,	2,3,0,	1,5,6,
		6,2,1,	7,6,5,	5,4,7,
		4,0,3,	3,7,4,	4,5,1,
		1,0,4,	3,2,6,	6,7,3
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

		//VBO ť��
		glGenBuffers(1, &ibo_cube_elements);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo_cube_elements);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cube_elements), cube_elements, GL_STATIC_DRAW);


	glBindVertexArray(0); // VAO�� close
}

void MyGlWindow::draw() 
{
	glClearColor(0.2f, 0.2f, 0.2f, 1.f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glViewport(0, 0, m_width, m_height);
	glEnable(GL_DEPTH_TEST);

	//�׷���
	shaderProgram->use(); // vertex shader ȣ��

		glBindVertexArray(vaoHandle);

		//normal draw
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
		glDrawArrays(GL_TRIANGLE_STRIP, 2, 5);
		
		//cube
		//int size;
		//glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
		//glDrawElements(GL_TRIANGLES, size / sizeof(GLushort), GL_UNSIGNED_SHORT, 0);

	shaderProgram->disable(); // vertex shader close
}

void MyGlWindow::setSize(int w, int h)
{
	m_width = w;
	m_height = h;
}