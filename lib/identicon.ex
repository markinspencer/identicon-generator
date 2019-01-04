defmodule Identicon do
  def main(input) do
    input
    |> hash_input
  end

  def hash_input(input) do
    seed = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{seed: seed}
  end
end
