-Get aggregate of low asking price, high asking price
SELL FAST
LIKELY SALE IN TIME
OUTLIERS

class CreateMedianFunction < ActiveRecord::Migration[5.0]
  def change
    create_table :median_functions do |t|
      def up
        ActiveMedian.create_function
      end

      def down
        ActiveMedian.drop_function
      end
    end
  end
end
