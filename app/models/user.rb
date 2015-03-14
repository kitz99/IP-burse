class User < ActiveRecord::Base
  attr_accessible :uid, :first_name, :last_name, :iban, :bank, :email, :id

  def show_by_id(options={})
    User.where(id: options[:id])
  end

  def exec(str)
    ActiveRecord::Base.connection.execute(str)
  end
end
