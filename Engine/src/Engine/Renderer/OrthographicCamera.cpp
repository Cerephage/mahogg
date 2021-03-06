#include "enpch.h"
#include "Engine/Renderer/OrthographicCamera.h"
#include <glm/gtc/matrix_transform.hpp>

namespace Engine
{
  OrthographicCamera::OrthographicCamera(float left, float right, float bottom, float top)
    : m_ProjectionMatrix(glm::ortho(left, right, bottom, top, -1.0f, 1.0f)), m_ViewMatrix(1.0f)
  {
    EN_PROFILE_FUNCTION();

    m_ViewProjectionMatrix = m_ProjectionMatrix * m_ViewMatrix;
  }

  // If View Matrix already exists...
  void OrthographicCamera::SetProjection(float left, float right, float bottom, float top)
  {
    EN_PROFILE_FUNCTION();

    m_ProjectionMatrix = glm::ortho(left, right, bottom, top, -1.0f, 1.0f);
    m_ViewProjectionMatrix = m_ProjectionMatrix * m_ViewMatrix;
  }

  // If Projection Matrix already exists...
  void OrthographicCamera::RecalculateViewMatrix()
  {
    EN_PROFILE_FUNCTION();

    glm::mat4 transform = glm::translate(glm::mat4(1.0f), m_Position) *
      glm::rotate(glm::mat4(1.0f), glm::radians(m_Rotation), glm::vec3(0, 0, 1));

    m_ViewMatrix = glm::inverse(transform);
    m_ViewProjectionMatrix = m_ProjectionMatrix * m_ViewMatrix;
  }
}