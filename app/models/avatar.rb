class Avatar
  def self.url_for (party, size = 80, default = "mm")
    return gravatar_for(party.email, size, default) if party.class <= Person || party.class <= User
    return default_avatar if party.nil?
    return group_avatar
  end

  def self.gravatar_for (email, size = 80, default = "mm")
    if email.present?
      "https://secure.gravatar.com/avatar/#{gravatar_key(email)}.png?s=#{size}&d=#{default}&rating=pg&refresh=#{refresh_token}"
    else
      default_avatar
    end
  end

  def self.gravatar_key (email)
    Digest::MD5.hexdigest(email.downcase)
  end

  def self.default_avatar
    "/images/mug_default.png"
  end

  def self.group_avatar
    "/images/lotus/40.png"
  end

  def self.refresh_token
    Rails.env.test? ? 1 : rand
  end
end
