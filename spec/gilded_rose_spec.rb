require 'gilded_rose'

RSpec.describe GildedRose do
  subject (:gilded_rose) { GildedRose.new(items) }
  let (:dexterity_vest) { Item.new("+5 Dexterity Vest", 10, 10) }
  let (:elixir) { Item.new("Elixir of the Mongoose", 10, 10) }
  let (:aged_brie) { Item.new("Aged Brie", 10, 10) }
  let (:sulfuras) { Item.new("Sulfuras, Hand of Ragnaros", 10, 10) }
  let (:backstage_pass) { Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 10) }
  let (:items) { [dexterity_vest, elixir, aged_brie, sulfuras, backstage_pass] }


  describe "#update_quality" do
    it "does not change the name" do
      gilded_rose.update_quality
      expect(gilded_rose.items[0].name).to eq "+5 Dexterity Vest"
    end

    it "decreases the sell-in value by one" do
      gilded_rose.update_quality
      expect(gilded_rose.items[0].sell_in).to eq 9
      expect(gilded_rose.items[1].sell_in).to eq 9
      expect(gilded_rose.items[2].sell_in).to eq 9
      expect(gilded_rose.items[4].sell_in).to eq 14
    end

    it "decreases the Quality value of Dexterity & Elixir by one" do
      gilded_rose.update_quality
      expect(gilded_rose.items[0].quality).to eq 9
      expect(gilded_rose.items[1].quality).to eq 9
    end

    it "decreases Quality by 2 for Dexterity & Elixir, if sell-in date passed" do
      dexterity_vest.sell_in = -1
      elixir.sell_in = -1
      gilded_rose.update_quality
      expect(gilded_rose.items[0].quality).to eq 8
      expect(gilded_rose.items[1].quality).to eq 8
    end

    it "never allows Quality of item to be negative" do
      dexterity_vest.quality = 0
      gilded_rose.update_quality
      expect(gilded_rose.items[0].quality).to eq 0
    end

    it "increases the Quality of Aged Brie" do
      gilded_rose.update_quality
      expect(gilded_rose.items[2].quality).to eq 11
    end

    it "Aged Brie, Sulfuras & Backstage Passes have a maximum Quality of 50" do
      aged_brie.quality = 50
      backstage_pass.quality = 50
      sulfuras.quality = 50
      gilded_rose.update_quality
      expect(gilded_rose.items[2].quality).to eq 50
      expect(gilded_rose.items[3].quality).to eq 50
      expect(gilded_rose.items[4].quality).to eq 50
    end

    it "Sulfuras sell-in date remains the same" do
      gilded_rose.update_quality
      expect(gilded_rose.items[3].sell_in).to eq 10
    end

    it "Sulfuras Quality never decreases" do
      gilded_rose.update_quality
      expect(gilded_rose.items[3].quality).to eq 10
    end

    it "Backstage passes increases Quality by 2 when less than 10 days of sell-in" do
      backstage_pass.sell_in = 10
      gilded_rose.update_quality
      expect(gilded_rose.items[4].quality).to eq 12
    end

    it "Backstage passes increases Quality by 3 when less than 5 days of sell-in" do
      backstage_pass.sell_in = 5
      gilded_rose.update_quality
      expect(gilded_rose.items[4].quality).to eq 13
    end

    it "Backstage passes Quality drops to 0 at sell-by date" do
      backstage_pass.sell_in = 0
      gilded_rose.update_quality
      expect(gilded_rose.items[4].quality).to eq 0
    end
  end
end
