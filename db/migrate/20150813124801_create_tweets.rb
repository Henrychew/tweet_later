
class CreateTweets < ActiveRecord::Migration

  def change

    create_table  :tweets do |x|

      x.belongs_to  :user
      x.string    :uid
      x.string    :status

      x.timestamps

    end


  end



end