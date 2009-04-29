#include "ComponentSerializerFactory.h"

#include "../../System/SystemType.hpp"

#include "AIComponentSerializer.h"
#include "GraphicsComponentSerializer.h"
#include "GeometryComponentSerializer.h"
#include "PhysicsComponentSerializer.h"
#include "InputComponentSerializer.h"
#include "AIComponentSerializer.h"
#include "ScriptComponentSerializer.h"

namespace Serialization
{

	IComponentSerializer* ComponentSerializerFactory::Create( const System::Types::Type& systemType )
	{
		IComponentSerializer* strategy = 0;

		if( systemType == System::Types::RENDER )
		{
			strategy = new GraphicsComponentSerializer( );
		} 
		else if ( systemType == System::Types::GEOMETRY )
		{
			strategy = new GeometryComponentSerializer( );
		}
		else if ( systemType == System::Types::PHYSICS )
		{
			strategy = new PhysicsComponentSerializer( );
		}
		else if ( systemType == System::Types::INPUT )
		{
			strategy = new InputComponentSerializer( );
		}
		else if ( systemType == System::Types::AI )
		{
			strategy = new AIComponentSerializer( );
		}
		else if ( systemType == System::Types::SCRIPT )
		{
			strategy = new ScriptComponentSerializer( );
		}

		return strategy;
	}
}