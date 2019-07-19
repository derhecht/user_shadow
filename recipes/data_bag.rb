bag = node['user']['data_bag_name']

# Fetch the user array from the node's attribute hash. If a subhash is
# desired (ex. node['base']['user_accounts']), then set:
#
#     node['user']['user_array_node_attr'] = "base/user_accounts"
user_array = node
node['user']['user_array_node_attr'].split("/").each do |hash_key|
  user_array = user_array.send(:[], hash_key)
end

# only manage the subset of users defined
Array(user_array).each do |i|
  u = data_bag_item(bag, i.gsub(/[.]/, '-'))

  user_shadow u['username'] do
    sp_lstchg u['sp_lstchg'] if u['sp_lstchg']
    sp_expire u['sp_expire'] if u['sp_expire']
    sp_min u['sp_min'] if u['sp_min']
    sp_max u['sp_max'] if u['sp_max']
    sp_inact u['sp_inact'] if u['sp_inact']
    sp_warn u['sp_warn'] if u['sp_warn']
  end
end
