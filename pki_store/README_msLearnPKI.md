# Implement and manage Active Directory Certificate Services

https://learn.microsoft.com/en-us/training/modules/implement-manage-active-directory-certificate-services/

## Explore the fundamentals of PKI and AD CS

To obtain certificates for your AD DS infrastructure, you can request them from a public CA or issue them by using your own infrastructure. To implement your own CA, you can use AD CS.

* AD CS is an identity technology in Windows Server that allows you to implement PKI for your organization.

* PKI is the combination of software, encryption technologies, processes, and services that enable an organization to secure its data, communications, and business transactions. 

* You can implement a PKI solution by using the AD CS Windows Server role. 

AD CS provides all PKI-related components as role services. Each role service is responsible for a specific portion of the certificate infrastructure while working together to form a complete solution.


The AD CS role includes the following role services:

* Certification Authority
* Certification Authority Web Enrollment. This component provides a method to issue and renew certificates in scenarios where users use devices that are not joined to the domain or are running operating systems other than Windows.
* Online Responder. You can use this component to configure and manage Online Certificate Status Protocol (OCSP) validation and revocation checking.
* Network Device Enrollment Service (NDES). With this component, routers, switches, and other network devices can obtain certificates from AD CS.

Certificate Enrollment Web Service (CES). This component works as a proxy client between a computer running Windows and the CA. CES enables users, computers, or applications to connect to a CA by using web services to:

* Request, renew, and install issued certificates.
* Retrieve certificate revocation lists (CRLs).
* Download a root certificate.
* Enroll over the internet or across forests.
* Renew certificates automatically for computers that are part of untrusted AD DS domains or are not joined to a domain.

* Certificate Enrollment Policy Web Service. This component enables users to obtain certificate enrollment policy information.

## Design and Impement AD DC

As part of your design, you should decide how many CA tiers you need and what will be the purpose of the CA in each tier.

We don't recommend building a CA hierarchy deeper than three levels, unless it is in a complex, highly secure, or distributed environment.

* Most commonly, CA hierarchies have two levels, with the root CA at the top level and a subordinate, issuing CA on the second level.

NOTE! 

A multilevel CA hierarchy isn't mandatory. For smaller, less complex environments, you can implement a root CA only. In such case, the root CA also provides certificate issuance and management functionality.

#### Standalone vs. enterprise CAs

When using AD CS, you can deploy two types of CAs: standalone and enterprise. These types of CAs are not about hierarchy, but instead, about functionality and integration with AD DS.


A standalone CA doesn't depend on AD DS. An enterprise CA requires AD DS, to provide additional functionality, such as autoenrollment. Autoenrollment allows domain users and domain-joined devices to enroll automatically for certificates after you enable automatic certificate enrollment through Group Policy.

There are also some considerations specific to deployment of an offline, standalone root CA:

* Before you issue a subordinate certificate from the root CA, make sure that you provide at least one certificate revocation list distribution point (CDP) and AIA location that will be available to all clients.
* Set a validity period for CRLs that the root CA publishes to a long period of time, for example, one year.
* Use Group Policy to publish the root CA certificate to a trusted root CA store on all server and client computers.

## Manage certificate enrollment

* A certificate is a small file that contains several pieces of information about its owner. This data can include the owner's email address, the owner's name, the certificate usage type, the validity period, and the URLs for AIA and CDP locations.
* Certificate templates define how users and devices can request and use Enterprise CA issued certificates based on that template. 


## Manage certiticate revocation

Revocation is the process in which you disable the validity of one or more certificates. By initiating the revocation process, you publish a certificate thumbprint in the corresponding CRL. This indicates that a specific certificate is no longer valid.

NOTE!

Every certificate has its own validity period, after which it is no longer considered valid. With revocation, you can invalidate the certificate before that period passes, for example, to remediate certificate compromise.

## Manage certificate trusts

When using certificates, it is important that you consider who or what might need to assess their authenticity and validity. There are three types of certificates that you can use:

* Internal certificates from an organizational CA, such as a server hosting the AD CS role.
* External certificates from a public CA such as an organization that provides commercial cybersecurity software or identity services.
* A self-signed certificate.

If you deploy an Enterprise Root CA and use it to enroll certificates onto your users' domain-joined devices, these devices will accept the enrolled certificates as trusted. However, any workgroup device will consider the same certificates as untrusted. To resolve this issue, you can:

* Obtain public certificates from an external CA for the workgroup devices. This comes with an extra cost of public certificates.
* Configure the workgroup devices to trust the Enterprise Root CA. This requires additional configuration.

#### Manage certificates and certificate trusts in Windows


You can manage certificates that are stored within the Windows operating system by using a range of tools, including Windows Admin Center, the Certificates Microsoft Management Console snap-in, Windows PowerShell, and certutil command line tool.


Each store consists of several folders, including:

* Personal, to local user, computer or service.
* Trusted Root Certificate Authorities, containes certificates of trusted root CAs.
* Enterprice Trust, containes certificates of trusted root CAs from other organizations.
* Intermediate Certificate Authorities, Contains certificates issued to subordinate CAs.

#### Create a self-signed certificate for testing purposes

While self-signed certificates are not suitable for production scenarios, they can be useful for testing purpose (bullshit).

```ps1
# The following example creates a self-signed SSL server certificate in the local machine personal store 
# with the subject alternative name set to www.fabrikam.com, www.contoso.com 
# and Subject and Issuer name set to www.fabrikam.com

New-SelfSignedCertificate -DnsName "www.fabrikam.com", "www.contoso.com" -CertStoreLocation "cert:\LocalMachine\My"
```
