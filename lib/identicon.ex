defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
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
