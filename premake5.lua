workspace "Engine"
  architecture "x64"
  startproject "Sandbox"
  
  configurations
  {
    "Debug",
    "Release",
    "Dist"
  }
  
  flags
  {
    "MultiProcessorCompile"
  }
  
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Engine/vendor/GLFW/include"
IncludeDir["Glad"] = "Engine/vendor/Glad/include"
IncludeDir["ImGui"] = "Engine/vendor/imgui"
IncludeDir["glm"] = "Engine/vendor/glm"
IncludeDir["stb_image"] = "Engine/vendor/stb_image"

include "Engine/vendor/GLFW"
include "Engine/vendor/Glad"
include "Engine/vendor/imgui"
  
project "Engine"
  location "Engine"
  kind "StaticLib"
  language "C++"
  cppdialect "C++17"
  staticruntime "on"
  
  targetdir ("bin/" .. outputdir .. "/%{prj.name}")
  objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

  pchheader "enpch.h"
  pchsource "Engine/src/enpch.cpp"
  
  files
  {
    "%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl",
    "%{prj.name}/vendor/stb_image/**.h",
    "%{prj.name}/vendor/stb_image/**.cpp"
  }

  defines
  {
    "_CRT_SECURE_NO_WARNINGS"
  }
  
  includedirs
  {
    "%{prj.name}/src",
    "%{prj.name}/vendor/spdlog/include",
    "%{IncludeDir.GLFW}",
    "%{IncludeDir.Glad}",
    "%{IncludeDir.ImGui}",
    "%{IncludeDir.glm}",
    "%{IncludeDir.stb_image}"
  }

  links
  {
    "GLFW",
    "Glad",
    "ImGui",
    "opengl32.lib"
  }
  
  filter "system:windows"
    systemversion "latest"
    
    defines
    {
        "EN_BUILD_DLL",
        "GLFW_INCLUDE_NONE"
    }
    
    filter "configurations:Debug"
      defines "EN_DEBUG"
      runtime "Debug"
      symbols "on"
    
    filter "configurations:Release"
      defines "EN_RELEASE"
      runtime "Release"
      optimize "on"
      
    filter "configurations:Dist"
      defines "EN_DIST"
      runtime "Release"
      optimize "on"
      
project "Sandbox"
  location "Sandbox"
  kind "ConsoleApp"
  language "C++"
  cppdialect "C++17"
  staticruntime "on"
  
  targetdir ("bin/" .. outputdir .. "/%{prj.name}")
  objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
  
  files
  {
    "%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
  }
  
  includedirs
  {
    "Engine/vendor/spdlog/include",
    "Engine/src",
    "Engine/vendor",
    "%{IncludeDir.glm}"
  }
  
  links
  {
    "Engine"
  }
  
  filter "system:windows"
    systemversion "latest"
    
    filter "configurations:Debug"
      defines "EN_DEBUG"
      runtime "Debug"
      symbols "on"
    
    filter "configurations:Release"
      defines "EN_RELEASE"
      runtime "Release"
      optimize "on"
      
    filter "configurations:Dist"
      defines "EN_DIST"
      runtime "Release"
      optimize "on"