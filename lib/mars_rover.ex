defmodule MarsRover do
  @moduledoc """
  Documentation for `MarsRover` module. This module takes an input made of a grid and details about robots including a starting position and a series of moves.
  For each robot, the module uses the initial position, applies the moves to the robot and prints out its final position, or it's last known position if the robot
  has moved off the grid.
  """

  def get_results(grid, robots) do
    with {:ok, grid} <- check_grid(grid),
         {:ok, checked_robots} <- check_robots(robots) do
      Enum.map(checked_robots, fn robot -> update_robot(robot, grid) end)
      |> format_output()
    else
      {:error, :wrong_input_format} ->
        {:error,
         "The expected input is composed of a grid {m, n} where m and n are integers, and a list of robots details. Please check the input before trying again."}

      {:error, :wrong_robot_format} ->
        {:error,
         "The expected format for a robot is a 3 items list containing details of the initial position and a string representing a series of moves. Please check the input matches the required format before trying again."}

      {:error, :no_robots_details} ->
        {:error, "Please provide the details for at least one robot before trying again."}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Apply move

  ## Examples

      iex> MarsRover.apply_move("L", %{x: 2, y: 3, o: "N"})
      %{x: 2, y: 3, o: "W"}

      iex> MarsRover.apply_move("R", %{x: 2, y: 3, o: "E"})
      %{x: 2, y: 3, o: "S"}

      iex> MarsRover.apply_move("F", %{x: 2, y: 3, o: "S"})
      %{x: 2, y: 2, o: "S"}

  """

  def apply_move("L", current_position) do
    new_orientation =
      case String.upcase(current_position.o) do
        "N" -> "W"
        "E" -> "N"
        "S" -> "E"
        "W" -> "S"
      end

    Map.put(current_position, :o, new_orientation)
  end

  def apply_move("R", current_position) do
    new_orientation =
      case String.upcase(current_position.o) do
        "N" -> "E"
        "E" -> "S"
        "S" -> "W"
        "W" -> "N"
      end

    Map.put(current_position, :o, new_orientation)
  end

  def apply_move("F", current_position = %{x: x, y: y, o: o}) do
    {key_to_update, new_value} =
      case String.upcase(o) do
        "N" -> {:y, y + 1}
        "E" -> {:x, x + 1}
        "S" -> {:y, y - 1}
        "W" -> {:x, x - 1}
      end

    Map.put(current_position, key_to_update, new_value)
  end

  defp check_grid(grid = {grid_dim_1, grid_dim_2})
       when is_integer(grid_dim_1) and is_integer(grid_dim_2) do
    {:ok, grid}
  end

  defp check_grid(_grid), do: {:error, :wrong_input_format}

  defp check_robots([]), do: {:error, :no_robots_details}

  defp check_robots(robots) when is_list(robots) do
    Enum.reduce_while(robots, {:ok, []}, fn robot, {:ok, acc} ->
      case robot do
        {position, moves} when is_list(position) and length(position) == 3 and is_binary(moves) ->
          {:cont, {:ok, acc ++ [robot]}}

        _ ->
          {:halt, {:error, :wrong_robot_format}}
      end
    end)
  end

  defp check_robots(_robots), do: {:error, :wrong_input_format}

  defp update_robot({[x_pos, y_pos, orientation], moves}, grid) do
    initial_position = %{x: x_pos, y: y_pos, o: orientation}

    if is_within_grid?(initial_position, grid) do
      handle_moves(moves, initial_position, grid)
    else
      %{last_position: initial_position, lost: true}
    end
  end

  defp is_within_grid?(%{x: x, y: y}, {dim_1, dim_2}) do
    x in 0..dim_1 and y in 0..dim_2
  end

  defp handle_moves(moves, initial_position, grid) do
    Enum.reduce_while(
      String.split(moves, "", trim: true),
      %{last_position: initial_position, lost: false},
      fn
        move, acc ->
          new_position = apply_move(move, acc.last_position)

          if is_within_grid?(new_position, grid) do
            {:cont, Map.put(acc, :last_position, new_position)}
          else
            {:halt, Map.put(acc, :lost, true)}
          end
      end
    )
  end

  defp format_output(robots_final_data) do
    Enum.each(robots_final_data, fn %{last_position: %{x: x, y: y, o: o}, lost: lost} ->
      formatted_position = "(#{x}, #{y}, #{o})"

      if lost do
        IO.puts("#{formatted_position} LOST")
      else
        IO.puts("#{formatted_position}")
      end
    end)
  end
end
