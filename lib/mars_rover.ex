defmodule MarsRover do
  @moduledoc """
  Documentation for `MarsRover` module which contains functions allowing to read the input that's given, update the robots, and print out their final state
  """

  def mars_rover(grid, robots) do
    with {:ok, _grid} <- check_grid(grid),
         {:ok, _robots} <- check_robots(robots) do
      :lets_update_thos_robots
    else
      {:error, :wrong_input_format} ->
        {:error,
         "The expected input is composed of a grid {m, n} where m and n are integers, and a list of robots details. Please check the input before trying again."}

      {:error, :no_robots} ->
        {:error, "Please provide the details for at least one robot before trying again."}
    end
  end

  @doc """
  Check grid format

  ## Examples

      iex> MarsRover.check_grid({4, 8})
      {:ok, {4, 8}}

      iex> MarsRover.check_grid({4, "eight"})
      {:error, :wrong_input_format}

      iex> MarsRover.check_grid([4, 8])
      {:error, :wrong_input_format}

  """

  def check_grid(grid = {grid_dim_1, grid_dim_2})
      when is_integer(grid_dim_1) and is_integer(grid_dim_2) do
    {:ok, grid}
  end

  def check_grid(_grid), do: {:error, :wrong_input_format}

  @doc """
  Check robots format

  ## Examples

      iex> MarsRover.check_robots([])
      {:error, :no_robots}

      iex> MarsRover.check_robots(["robot_1"])
      {:ok, ["robot_1"]}

      iex> MarsRover.check_robots(["robot_1", "robot_2"])
      {:ok, ["robot_1", "robot_2"]}

      iex> MarsRover.check_robots(%{robot: "robot"})
      {:error, :wrong_input_format}

  """

  def check_robots([]), do: {:error, :no_robots}

  def check_robots(robots) when is_list(robots), do: {:ok, robots}

  def check_robots(_robots), do: {:error, :wrong_input_format}
end
