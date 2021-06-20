defmodule FrontiersSite.Model.Frontier do
  @max_rows 25
  @max_cols 25
  @length @max_rows * @max_cols
  @resource_allocations [mines: 0.03, dairy: 0.1, wood: 0.3]

  alias FrontiersSite.Model.Frontier

  defmodule Tile do
    defstruct [terrain: :grass, hero: :none, resource: :none]
  end

  defstruct tiles: [], public_key: "YEET"

  def empty(pk) do

    tiles = for _idx <- 0..@length-1, do:
       %Tile{
        terrain: :grass,
        hero: :none,
        resource: :none
    }

    %Frontier{
      tiles: tiles,
      public_key: pk
    }
  end

  def new(pk) do
    empty(pk)
    |> place_wood_resources()
    |> place_dairy_resources()
    |> place_mines()
    |> place_silo
  end

  defp place_wood_resources(f = %Frontier{}) do
    %Frontier{
      f
      | tiles:
          0..@length-1 |> Enum.map(fn idx -> wood_or_default(Enum.at(f.tiles, idx)) end)
    }
  end

  defp wood_or_default(default) do
    rnd = :rand.uniform()

    if rnd >= @resource_allocations[:dairy] &&
         rnd < @resource_allocations[:wood] do
      %Tile{ default | resource: :wood}
    else
      default
    end
  end

  defp place_dairy_resources(f = %Frontier{}) do
    %Frontier{
      f
      | tiles:
          0..@length-1 |> Enum.map(fn idx -> dairy_or_default(Enum.at(f.tiles, idx)) end)
    }
  end

  defp dairy_or_default(default) do
    rnd = :rand.uniform()

    if rnd >= @resource_allocations[:mines] &&
         rnd < @resource_allocations[:dairy] do
      %Tile{ default | resource: :dairy}
    else
      default
    end
  end

  defp place_mines(f = %Frontier{}) do
    %Frontier{
      f
      | tiles:
          0..@length-1 |> Enum.map(fn idx -> mine_or_default(Enum.at(f.tiles, idx)) end)
    }
  end

  defp mine_or_default(default) do
    rnd = :rand.uniform()

    if rnd >= 0 &&
         rnd <= @resource_allocations[:mines] do
      %Tile{ default | resource: :mine}
    else
      default
    end
  end

  defp place_silo(f = %Frontier{}) do
    tile = Enum.at(f.tiles, center() |> index())
    tile = %Tile{ tile | terrain: :silo, resource: :none}

    center_idx = center() |> index()
    IO.puts center_idx

    %Frontier{
      f
      | tiles:
          List.replace_at(
            f.tiles,
            center()
            |> index(),
            tile
          ),
    }
  end

  def index({row, col}) do
    (row * @max_rows) + col
  end

  def center() do
    {div(@max_rows, 2), div(@max_cols, 2)}
  end
end
