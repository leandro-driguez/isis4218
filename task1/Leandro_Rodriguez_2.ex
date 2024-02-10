
defmodule WallE do

  defstruct direction: 0, position: {0, 0}

  @valid_directions [:north, :east, :south, :west]
  @direction_deltas_x [0, 1, 0, -1]
  @direction_deltas_y [1, 0, -1, 0]

  @doc """
    Create a Robot Simulator given an initial direction and position.
    Valid directions are: :north, :east, :south, :west
  """
  @spec create(atom, { integer , integer } ) :: any
  def create(direction, position) do
    index = Enum.find_index(@valid_directions, fn dir -> dir == direction end)
    %WallE{direction: index, position: position}
  end

  @doc """
    Simulate the robot’s movement given a string of instructions .
    Valid instructions are : " R " ( turn right ) , " L " , ( turn left ) , and " A " (advance )
  """
  @spec simulate(any, String.t()) :: any
  def simulate(robot, instructions) do
    _simulate(
      robot,
      String.graphemes(instructions)
    )
  end

  defp _simulate(robot, []), do: robot
  defp _simulate(robot, ["L" | instructions]) do
    turn_left(robot)
    |> _simulate(instructions)
  end
  defp _simulate(robot, ["R" | instructions]) do
    turn_right(robot)
    |> _simulate(instructions)
  end
  defp _simulate(robot, ["A" | instructions]) do
    advance(robot)
    |> _simulate(instructions)
  end

  defp turn_left(robot) do
    Map.update!(
      robot, :direction,
      fn 0 -> 3
        direction -> direction-1
      end
    )
  end

  defp turn_right(robot) do
    Map.update!(
      robot, :direction,
      fn 3 -> 0
        direction -> direction+1
      end
    )
  end

  defp advance(robot) do
    dx = Enum.at(@direction_deltas_x, robot.direction)
    dy = Enum.at(@direction_deltas_y, robot.direction)

    new_position = {elem(robot.position, 0) + dx, elem(robot.position, 1) + dy}

    %WallE{robot | position: new_position}
  end

  @doc """
    Return the robot ’s direction.
    Valid directions are : :north, :east, :south, :west
  """
  @spec direction(any) :: atom
  def direction(robot) do
    Enum.at(@valid_directions, robot.direction)
  end

  @doc """
    Return the robot ’s position .
  """
  @spec position(any) :: { integer , integer }
  def position(robot) do
    robot.position
  end

end
