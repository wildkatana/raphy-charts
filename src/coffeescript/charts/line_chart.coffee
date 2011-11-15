# @import point.coffee
# @import bezier.coffee
# @import scaling.coffee
# @import tooltip.coffee
# @import dot.coffee
# @import line_chart_options.coffee
# @import line.coffee
# @import grid.coffee

class LineChart
  constructor: (dom_id, options = {}) ->
    container = document.getElementById(dom_id)
    [@width,@height] = @get_dimensions(container)
    @padding = 40 
    @options = new LineChartOptions(options)

    @r = Raphael(container, @width, @height)

    @all_points   = []
    @line_indices = []
    @line_options = []

  get_dimensions: (container) ->
    width  = parseInt(container.style.width)
    height = parseInt(container.style.height)
    [width, height]

  add_line: (points, options = @options) ->
    points_count  = @all_points.length
    @line_indices.push [points_count, points_count + points.length-1]
    @all_points.push.apply(@all_points, points)
    @line_options.push new LineChartOptions(options)
    return

  draw: () ->
    @r.clear()
    @scaled_points = Scaling.scale_points(@width, @height, @all_points, @padding)
    effective_width = @width + @padding


    for line_indices, i in @line_indices
      [begin, end] = line_indices
      points = @scaled_points[begin..end]
      raw_points = @all_points[begin..end]
      new Line(
        @r,
        raw_points,
        points,
        @height,
        effective_width,
        @line_options[i]
      ).draw()

    if @options.show_grid == true || @options.show_grid == "true"
      grid = new Grid(@r, @width, @height, @options)
      grid.draw()

    return
      
