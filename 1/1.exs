#!/usr/bin/env elixir

defmodule AOC2018.Day1 do
  def part1 do
    stream_changes()
    |> Enum.reduce(&sum/2)
    |> IO.inspect(label: "result")
  end

  def part2 do
    freqs = stream_changes()
    |> Enum.into([])

    try do
      Stream.cycle(freqs)
      |> Enum.reduce({0, MapSet.new([0])}, &find_frequency/2)
    catch
      x -> IO.puts("result:  #{inspect(x)}")
    end
  end


  def find_frequency(change, {current_freq, found_freq}) do
    new_frequency = current_freq + change
    if MapSet.member?(found_freq, new_frequency) do
      throw(new_frequency)
    end
    {new_frequency, MapSet.put(found_freq, new_frequency)}
  end

  defp stream_changes() do
    IO.stream(:stdio, :line)
    |> Stream.map(&to_integer/1)
  end

  defp sum(value, sum), do: sum + value

  defp to_integer("+" <> value), do: to_integer(value)
  defp to_integer(value), do: value |> String.trim() |> String.to_integer()
end

AOC2018.Day1.part2()
