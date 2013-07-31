# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  Movie.create!( movies_table.hashes )
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  idx1 = page.body.index(e1)
  idx2 = page.body.index(e2)
  idx1.should < idx2
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split( /, */).each do |rating|
    if uncheck != nil then
      step "I uncheck \"ratings_#{rating}\""
    else
      step "I check \"ratings_#{rating}\""
      puts "I check \"ratings_#{rating}\""
    end
  end
end

Then /I should not see movies with the following ratings: (.*)/ do |ratings|
  ratings.split( /, */).each do |rating|
    page.find('td').should have_no_content(rating)
  end
end

Then /I should see movies with the following ratings: (.*)/ do |ratings|
  result = true
  ratings.split( /, */).each do |rating|
    result |= page.find('td').has_content?(rating)
  end
  result
end

Then /I should see all of the movies/ do
  rows = page.find_by_id('movies').all('tr')
  rows.each do |content|
    puts content.text
  end
  assert (rows.count-1) == Movie.count, "#{rows.count-1}, #{Movie.count}"
end

Then /I should see no movies/ do
  rows = page.find('table').all('tr')
  assert rows.count == 1
end
