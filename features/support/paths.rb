module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
      root_path
    when /the registration page/
      new_account_path
    when /the login page/
      login_path
    when /the logout page/
      logout_path
    when /the about page/
      '/pages/about'
    when /the contact page/
      '/pages/contact'
    when /user's profile page/
      account_path
    when /password reset page/
      edit_password_reset_path(1)
    when /my tags page/
      tags_path
    when /the tag page for "([^\"]+)"/
      "/tags/#{$1}"
    when /the atom feed for the tag "([^\"]+)"/
      tag_path(Tag.find_by_name($1), :format => 'atom')
    when /the summary atom feed for the tag "([^\"]+)"/
      summary_tag_path(Tag.find_by_name($1), :format => 'atom')
    when /the tracked tags atom feed for "([^\"]+)"/
      user_path(:id => $1,  :format => 'atom')
    when /the tracked tags summary atom feed for "([^\"]+)"/
      summary_user_path(:id => $1, :format => "atom")
      
      
    when /the admin login page/
      admin_login_path
    when /the admin logout page/
      admin_logout_path
    when /the admin dashboard page/
      admin_dashboard_path
    when /the admin links page/
      admin_links_path
    when /the link reports page/
      reports_admin_links_path
    when /the admin tags page/
      admin_tags_path
    when /the admin users page/
      admin_users_path
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
