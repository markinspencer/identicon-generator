defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do 
    pixel_map = Enum.map(grid, &to_pixel/1)
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def to_pixel({_code, index} = square) do 
    horizontal = rem(index, 5) * 50
    vertical = div(index, 5) * 50
    
    top_left = {horizontal, vertical}
    bottom_right = {horizontal + 50, vertical + 50}
    
    {top_left, bottom_right}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    updatedGrid = Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: updatedGrid}  
  end

  def build_grid(%Identicon.Image{seed: seed} = image) do 
    grid = 
      seed
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
    
    %Identicon.Image{image | grid: grid}  
  end

  def mirror_row([first, second | _tail] = row ) do 
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{seed: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}  
  end

  def hash_input(input) do
    seed = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{seed: seed}
  end
end
