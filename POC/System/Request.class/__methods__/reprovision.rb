#
# Description: This method will reprovision a virtual machine from a template tagged as "ha_policy/reprovision"
# Author: Kenneth D. Evensen <kenneth.evensen@redhat.com>
#
require 'json'
require 'rest-client'

@method = 'Reprovision'
$evm.log("info", "----Entering method #{@method}----")

host = $evm.root['host']


def createJsonRequest(miq_provision) 
  src_vm_id = miq_provision.options[:src_vm_id][0]
  src_vmobj =  $evm.vmdb('vm_or_template', src_vm_id)
  
  my_hash = {
    :version => "1.1", :template_fields => {:guid => "#{src_vmobj.guid}"}, 
    :vm_fields => {:number_of_sockets => miq_provision.options[:number_of_sockets][0], :cores_per_socket => miq_provision.options[:cores_per_socket][0], 
      :vm_name => "#{miq_provision.options[:vm_name]}_ha", :vm_memory => miq_provision.options[:vm_memory][0], :vlan => miq_provision.options[:vlan][0], :provision_type => ['native_clone', 'Native Clone']},
    :requester => {:user_name => "admin", :owner_first_name => "John", :owner_last_name => "Doe", :owner_email => "admin@example.com", :auto_approve => true},
    :tags => {:ha_policy => "reprovision"}
    }
  return src_vmobj, JSON.generate(my_hash)
end

def postProvisionRequest(src_vm, json_payload)

  url = "http://localhost:3000/api/provision_requests"
  user = "admin"
  password = "smartvm"
  
  
  if src_vm.tagged_with?("ha_policy","reprovision")
    response = RestClient::Request.new(
      :method => :post,
      :url => url,
      :user => user,
      :password => password,
      :verify_ssl => false,
      :payload => json_payload,
      :headers => { :accept => :json,
        :content_type => :json }
      ).execute


    $evm.log("info","Response - #{response}")
  else
    $evm.log("info","Source vm or template #{src_vm.name} is not tagged for reprovision")
  end

end

#$evm.root['ae_provider_category']='infrastructure'

host.vms.each do |vm|
  unless vm.nil?
    $evm.log("info","VM with name #{vm.name} is on host #{host.name}")
    unless vm.miq_provision.nil?
      src_vm, json_request = createJsonRequest(vm.miq_provision)
      $evm.log("info","========== Json Request: #{json_request}")
      postProvisionRequest(src_vm, json_request)
    end
  end
end

$evm.log("info", "----Exiting method #{@method}----")
