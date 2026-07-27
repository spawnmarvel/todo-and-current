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

There are also some considerations specific to deployment of an offline, standalone root CA:

* Before you issue a subordinate certificate from the root CA, make sure that you provide at least one certificate revocation list distribution point (CDP) and AIA location that will be available to all clients.
* Set a validity period for CRLs that the root CA publishes to a long period of time, for example, one year.
* Use Group Policy to publish the root CA certificate to a trusted root CA store on all server and client computers.

## Manage certificate enrollment

## Manage certiticate revocation

## Manage certificate trusts

