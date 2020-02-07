class ContactPresenter < Decorator

   def initialize (contact, template)
      super(contact)
      @contact = contact
      @template = template
   end

   attr_reader :template
   attr_reader :contact
   delegate :image_tag, to: :template
   
   def position_and_company
     [contact.position, contact.business_name].reject { |e| e.blank? }.join(' at ')
   end
   
   def engagement_rating_item
     %{
         <li>
         <div class="summary-label">Rating</div>
         <div class="summary-value">#{engagement_rating}</div>
         </li>
      }.html_safe
   end

   def engagement_rating
      rating = [contact.engagement_rating, 5].min
      full_stars = 1.upto(rating).to_a.map { |n| engagement_star_tag("on")  }
      empty_stars = 1.upto(5 - full_stars.count).to_a.map { |n| engagement_star_tag("off") }
      [full_stars, empty_stars].flatten.join.html_safe
   end

   private

   def engagement_star_tag (state)
      image_tag("contact/star_#{state}.png", :class => "engagement-rating-star #{state}", :width => "24", :height => "24")
   end

end
