# cloudforms-ha-reprovision
Traditional virtualization providers, such as RHEV, provide mechanisms to migrate a VM to a new host in the case of a host failure, thus creating an highly available workload.  However, sometimes the inctricacies of the workload necesitate a reporvision from a template rather than a migration.  This automation provides that mechanism.

This automate code…

1. Detects a host failure event
2. Determines what VM's were on that host
3. Determines from what template those VM's were cloned
4. If that VM is tagged with ha_policy, provision a VM from that template with the origional VM name + "_ha"

###Obtain Automate Code
1. Clone repository
2. Compress the POC folder as a ZIP archive

###Integration
1. Install and configure CloudForms
2. Login
3. Navigate to “Automate” —> Import/Export
4. Click browse
5. Navigate to the zipped archive
6. Upload the archive
7. Navigate to “Automate” —> “Explorer”
8. Ensure the POC domain is enabled
9. Navigate to “Automate” —> “Customization” and the “Buttons” accordionan on the left
10. Add a tag "ha_policy/reprovision"
11. Tag the base template you wish to reprovision
