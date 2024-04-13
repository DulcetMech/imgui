project "ImGui"
	kind "StaticLib"
	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"imgui.cpp",        
		"imgui_demo.cpp",
		"imgui_draw.cpp",
		"imgui_tables.cpp",
		"imgui_widgets.cpp",
		"imconfig.h",
		"imgui.h",
		"imgui_internal.h",
		"imstb_rectpack.h",
		"imstb_textedit.h",
		"imstb_truetype.h"
	}

	filter "system:windows"
		systemversion "latest"
		cppdialect "C++20"
		staticruntime "Off"

	filter "system:linux"
		pic "On"
		systemversion "latest"
		cppdialect "C++20"
		staticruntime "Off"

	filter "configurations:Debug"
		defines {"_CRT_SECURE_NO_WARNINGS" }
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines {"_CRT_SECURE_NO_WARNINGS" }
		runtime "Release"
		optimize "on"
