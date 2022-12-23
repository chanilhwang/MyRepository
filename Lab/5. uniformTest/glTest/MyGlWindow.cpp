#include "MyGlWindow.h"

MyGlWindow::MyGlWindow(int w, int h) : m_width(w), m_height(h)
{
	setupBuffer();
}

ShaderProgram* shaderProgram;

void MyGlWindow::setupBuffer() 
{
	shaderProgram = new ShaderProgram(); // ���̴� ������Ʈ ����
	shaderProgram->initFromFiles("simple.vert", "simple.frag");

	m_triangle = new ColorTriangle();
	shaderProgram->addUniform("model");
}

void MyGlWindow::draw() 
{
	glm::mat4 translate = glm::translate(glm::mat4(1.0), glm::vec3(0.2, 0.2, 0));

	//���� �ʱ�ȭ
	glClearColor(0.2f, 0.2f, 0.2f, 1.f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glViewport(0, 0, m_width, m_height);
	glEnable(GL_DEPTH_TEST);

	//�׷���
	shaderProgram->use(); // vertex shader ȣ��

		glUniformMatrix4fv(shaderProgram->uniform("model"), 1, GL_FALSE, glm::value_ptr(translate));
		m_triangle->draw();

	shaderProgram->disable(); // vertex shader close
}

void MyGlWindow::setSize(int w, int h)
{
	m_width = w;
	m_height = h;
}