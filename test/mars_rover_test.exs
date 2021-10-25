defmodule MarsRoverTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  doctest MarsRover

  describe "get_results/2" do
    setup do
      grid = {4, 8}
      robots = [{[2, 3, "E"], "LFRFF"}, {[0, 2, "N"], "FFLFRFF"}]

      %{grid: grid, robots: robots}
    end

    test "returns the expected result when the input format is correct", %{
      grid: grid,
      robots: robots
    } do
      robots_2 = [{[2, 3, "N"], "FLLFR"}, {[1, 0, "S"], "FFRLF"}]

      execute_1 = fn ->
        MarsRover.get_results(grid, robots)
      end

      assert capture_io(execute_1) == """
             (4, 4, E)
             (0, 4, W) LOST
             """

      execute_2 = fn ->
        MarsRover.get_results(grid, robots_2)
      end

      assert capture_io(execute_2) == """
             (2, 3, W)
             (1, 0, S) LOST
             """
    end

    test "if the initial position if off grid, it outputs the given position and the lost label",
         %{grid: grid} do
      robot = [{[6, 0, "S"], "FFRLF"}]

      execute = fn ->
        MarsRover.get_results(grid, robot)
      end

      assert capture_io(execute) == """
             (6, 0, S) LOST
             """
    end

    test "returns an error if the grid input is not formatted appropriately", %{robots: robots} do
      grid = {4, "eight"}

      {:error, error} = MarsRover.get_results(grid, robots)

      assert error ==
               "The expected input is composed of a grid {m, n} where m and n are integers, and a list of robots details. Please check the input before trying again."
    end

    test "returns an error if there is no robots in the input", %{grid: grid} do
      {:error, error} = MarsRover.get_results(grid, [])

      assert error == "Please provide the details for at least one robot before trying again."
    end

    test "returns an error if robots are not given as a list", %{grid: grid} do
      robots = %{robot_1: {[2, 3, "E"], "LFRFF"}, robot_2: {[0, 2, "N"], "FFLFRFF"}}

      {:error, error} = MarsRover.get_results(grid, robots)

      assert error ==
               "The expected input is composed of a grid {m, n} where m and n are integers, and a list of robots details. Please check the input before trying again."
    end

    test "returns an error if robots details are not formatted propertly", %{grid: grid} do
      robot = [{[2, 4], "FFLRF"}]

      {:error, error} = MarsRover.get_results(grid, robot)

      assert error ==
               "The expected format for a robot is a 3 items list containing details of the initial position and a string representing a series of moves. Please check the input matches the required format before trying again."
    end
  end
end
