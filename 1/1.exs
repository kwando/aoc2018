#!/usr/bin/env elixir

defmodule AOC2018.Day1 do
  def part1 do
    IO.stream(:stdio, :line)
    |> Stream.map(&to_integer/1)
    |> Enum.reduce(&sum/2)
    |> IO.inspect(label: "result")
  end

  defp sum(value, sum), do: sum + value

  defp to_integer("+" <> value), do: to_integer(value)
  defp to_integer(value), do: value |> String.trim() |> String.to_integer()
end

AOC2018.Day1.part1()
