/*!
	@file
	@author		Albert Semenov
	@date		01/2009
	@module
*/
#ifndef __GRAPH_NODE_SIMPLE_H__
#define __GRAPH_NODE_SIMPLE_H__

#include <MyGUI.h>
#include "BaseGraphNode.h"
#include "GraphConnectionSimple.h"
#include "GraphConnectionExtension.h"

namespace demo
{

	class GraphNodeSimple : public wraps::BaseGraphNode
	{
	public:
		GraphNodeSimple(const std::string& _name) :
			BaseGraphNode("NodeSimple.layout"),
			mName(_name),
			mConnectionIn1(nullptr),
			mConnectionOut1(nullptr),
			mConnectionIn2(nullptr),
			mConnectionOut2(nullptr)
		{
		}

	private:
		virtual void initialise()
		{
			mMainWidget->setCaption(mName);
			assignBase(mConnectionIn1, "ConnectionIn1");
			assignBase(mConnectionOut1, "ConnectionOut1");
			assignBase(mConnectionIn2, "ConnectionIn2");
			assignBase(mConnectionOut2, "ConnectionOut2");
		}

		virtual void shutdown()
		{
		}

	private:
		std::string mName;
		GraphConnectionSimple * mConnectionIn1;
		GraphConnectionSimple * mConnectionOut1;
		GraphConnectionExtension* mConnectionIn2;
		GraphConnectionExtension* mConnectionOut2;

	};

} // namespace demo

#endif // __GRAPH_NODE_SIMPLE_H__
