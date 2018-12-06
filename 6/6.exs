defmodule AOC2018.Day6 do
  def run() do
    coords = coordinates()
    |> Enum.into([])
    |> IO.inspect(label: "coords")


    bounds = coords
    |> Enum.reduce({:infinity, 0, 0, :infinity},
      fn({x, y}, {top, right, bottom, left})->

        {min(top, y), max(right, x), max(bottom,y ), min(left, x)}
      end)
    |> IO.inspect(label: "bounds")

    bounded_coords = coords
    |> Enum.filter(&within_bounds(&1, bounds))
    |> IO.inspect(label: "within bounds")

    {top, right, bottom, left} = bounds
    for y <- top..bottom, x <- left..right do
      closest = Enum.min_by(coords, &distance(&1, {x, y}))
    end

    paint_map(%{}, {5, 5}, 0)
    |> paint_map({5, 5}, 3)
    |> IO.inspect(label: "map")
  end

  def paint_map(map, {x, y}, 0) do
    Map.update(map, {x, y}, {x, y}, fn(_) -> false end)
  end

  def paint_map(map, {x, y}, n) do
    map = Enum.reduce((x - n)..(x + n), map, &Map.update(&2, {&1, y}, {x,y}, fn(_)-> false end))
    map = Enum.reduce((y - n)..(y + n), map, &Map.update(&2, {x, &1}, {x,y}, fn(_)-> false end))
  end


  def within_bounds({x, y}, {t, r, b, l}) do
    y > t && x < r && y < b && x > l
  end

  def distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def coordinates() do
    IO.stream(:stdio, :line)
    |> Stream.map(&parse_coordinates/1)
  end

  defp parse_coordinates(input) do
    [x, y] = input
    |> String.split(",", parts: 2)
    |> Enum.map(&( &1 |> String.trim() |> String.to_integer() ))

    {x, y}
  end
end

AOC2018.Day6.run()
