defmodule ExMon.PlayerTest do
  use ExUnit.Case

  alias ExMon.Player

  describe "build/4" do
    test "returns a player structure when passing valid parameters" do
      response = Player.build("TesUser", :chute, :soco, :cura)

      expected_response = %ExMon.Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "TesUser"
      }

      assert response == expected_response
    end
  end
end
