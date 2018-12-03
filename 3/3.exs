#!/usr/bin/env elixir
defmodule AOC2018.Day3 do
  def part_one do
    [path | _ ] = System.argv()

    File.stream!(path)
    |> Stream.map(&parse_line/1)
    |> calculate_overlaps()
    |> IO.inspect(label: "part 1")
  end

  def calculate_overlaps(stream) do
    Enum.reduce(stream, %{}, &add_overlap/2)
    |> Enum.count(fn({key, value}) ->  value > 1 end)
  end

  defp add_overlap({_, {top, left}, {height, width}}, data) do
    data
    |> add_cols({top, left}, width, height)
  end

  defp add_row(data, _, 0), do: data
  defp add_row(data, {top, left}, n), do: data |> increment_pos({top, left + n}) |> add_row({top, left}, n - 1)
  defp add_cols(data, _, _, 0), do: data
  defp add_cols(data, {top, left}, width, n), do: data |> add_row({top + n, left}, width) |> add_cols({top, left}, width, n - 1)

  defp increment_pos(data, pos) do
    Map.update(data, pos, 1, fn(current) -> current + 1 end)
  end

  defp parse_line(line) do
    [id, _, pos, size] = line
    |> String.trim()
    |> String.split(" ")

    {id, parse_pos(pos), parse_size(size)}
  end
  defp parse_pos(pos) do
    pos
    |> String.strip(?:)
    |> int_tuple(",")
  end
  defp parse_size(size), do: int_tuple(size, "x")

  defp int_tuple(value, separator) do
    [x, y] = value
    |> String.split(separator, parts: 2)
    |> Enum.map(&String.to_integer/1)
    {x, y}
  end
end

AOC2018.Day3.part_one()
