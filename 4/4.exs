defmodule AOC2018.Day4 do
  import String, only: [split: 3, to_integer: 1, slice: 2]

  def part_one() do
    [path] = System.argv()
    rows = File.stream!(path)
    |> Enum.into([])
    |> Enum.sort()
    |> Enum.map(&parse_row/1)
    #|> IO.inspect(label: "input")

    {guard, sleeps} = rows
    |> simulate(%{awake: true, guards: %{}})
    |> Enum.max_by(fn({_guard, passes}) -> calculate_duration(passes) end)

    {minute, _count} = sleeps
    |> max_sleep_frequency()

    IO.inspect([guard: guard, minute: minute, total: guard * minute], label: "part 1")
  end

  def part_two() do
    [path] = System.argv()
    rows = File.stream!(path)
    |> Enum.into([])
    |> Enum.sort()
    |> Enum.map(&parse_row/1)

    {guard, {minute, _count}} = rows
    |> simulate(%{awake: true, guards: %{}})
    |> Enum.map(fn({guard, sleeps}) -> {guard, max_sleep_frequency(sleeps)} end)
    |> Enum.max_by(fn({_guard, {minute, count}})-> count end)

    [guard: guard, minute: minute, answer: minute * guard]
    |> IO.inspect(label: "part 2")
  end

  defp max_sleep_frequency(sleeps) do
    sleeps
    |> calculate_sleep_frequency()
    |> Enum.max_by(&elem(&1, 1))
  end

  defp calculate_sleep_frequency(passes), do: calculate_sleep_frequency(passes, %{})
  defp calculate_sleep_frequency([], state), do: state
  defp calculate_sleep_frequency([%{first: from, last: to} | rest], state) do
    state = Enum.reduce(from..(to - 1), state, fn(n, state)-> Map.update(state, n, 1, &( &1 + 1)) end)
    calculate_sleep_frequency(rest, state)
  end

  defp calculate_duration(passes) do
    Enum.reduce(passes, 0, fn(%{first: f, last: l}, duration) -> (l - f) + duration end)
  end
  defp simulate(events, state) do
    %{guards: guards} = Enum.reduce(events, state, &evaluate/2)
    guards
  end
  defp evaluate({time, {:guard_change, [guardID]}}, state = %{awake: true}) do
    Map.merge(state, %{
      current_guard: guardID,
      since: time,
      awake: true
    })
  end
  defp evaluate({time, {:sleep, _}}, state) do
    %{ state | awake: false, since: time }
  end
  defp evaluate({time, {:wakeup, _}}, state = %{since: sleept_since, current_guard: guard, awake: false}) do
    #IO.inspect([time: time, since: sleept_since, guard: guard, duration: duration])
    %{ state | awake: true, since: time }
    |> add_sleep(guard, sleept_since, time)
  end
  defp add_sleep(state = %{guards: guards}, guard, %{minute: m1, hour: h1}, %{minute: m2, hour: h2}) when h1 == h2 do
    %{ state | guards: Map.update(guards, guard, [m1..m2], &([m1..m2 | &1])) }
  end

  defp parse_row(row) do
    input = row
    |> String.trim()

    timestamp = input
    |> slice(1..16)
    |> parse_timestamp()

    {timestamp, parse_action(slice(input, 19..-1))}
  end

  defp parse_timestamp(input) do
    [date, time] = split(input, " ", parts: 2)
    [hour, minute] = split(time, ":", parts: 2)
    [year, month, day] = split(date, "-", parts: 3)
    {
      {to_integer(year), to_integer(month), to_integer(day)},
      {to_integer(hour), to_integer(minute), 0}
    }
    |> NaiveDateTime.from_erl!()
  end

  defp parse_action("falls asleep"), do: {:sleep, []}
  defp parse_action("wakes up"), do: {:wakeup, []}
  defp parse_action("Guard #" <> rest) do
    [guardID | _] = String.split(rest, " ", parts: 2)
    {:guard_change, [to_integer(guardID)]}
  end
end

AOC2018.Day4.part_one()
AOC2018.Day4.part_two()
