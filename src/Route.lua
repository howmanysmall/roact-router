local Roact = require(script.Parent.Parent.Roact)
local Path = require(script.Parent.Path)

local Route = Roact.PureComponent:extend("Route")

function Route:init()
	local history = self._context.history

	self:setState({
		location = history.location
	})

	self.listener = history:listen(function(location)
		self:setState({
			location = location
		})
	end)
end

function Route:willUnmount()
	self.listener:disconnect()
end

function Route:render()
	local match = self.state.path:match(self.state.location)

	local props = {
		match = match,
		location = self.state.location,
		history = self._context.history
	}

	if match then
		if not self.props.exact or self.props.path == self.state.location then
			if self.props.component then
				return Roact.createElement(self.props.component, props)
			elseif self.props.render then
				return self.props.render(props)
			end
		end
	end

	if self.props.children then
		return self.props.children(props)
	end
end

function Route.getDerivedStateFromProps(props)
	return {
		path = Path.new(props.path)
	}
end

return Route