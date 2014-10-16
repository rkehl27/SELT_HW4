# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
      Movie.create(movie)
  end
  assert movies_table.hashes.size == Movie.all.count
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and che ck/uncheck the ratings
  # using the appropriate Capybara command(s)
  arg1.split(",").each do |rating|
      rating = rating.strip
      check("ratings_#{rating}")
     # if rating == "un"
     #    step %{I uncheck "ratings_#{field}"}
     # else
     #    step %{I check "ratings_#{field}"}
     # end
   end
  #flunk "Unimplemented"
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
   result = false   
   all("tr").each do |tr|
      ratings = arg1.split(",")
      ratings.each do |r|
         r.strip
         regex = Regexp.new("(^#{r}$)")
         if tr.has_content?(r)
               result = true
         end
       end
   end
   assert result
end

Then /^I should see all of the movies$/ do
  assert all("table#movies tbody tr").count == Movie.all.count
#flunk "Unimplemented"
end



