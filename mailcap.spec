Summary: Associates helper applications with particular file types.
Name: mailcap
Version: 2.0.2
Release: 1
Copyright: public domain
Group: System Environment/Base
Source0: %{name}-%{version}.tar.gz
BuildArchitectures: noarch
BuildRoot: /var/tmp/%{name}-root

%description
The mailcap file is used by the metamail program.  Metamail reads the
mailcap file to determine how it should display non-text or
multimedia material.  Basically, mailcap associates a particular type
of file with a particular program that a mail agent or other program 
can call in order to handle the file.

Mailcap should be installed to allow certain programs to be able to
handle non-text files.

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/etc
install -m 644 mailcap $RPM_BUILD_ROOT/etc
install -m 644 mailcap.vga $RPM_BUILD_ROOT/etc
install -m 644 mime.types $RPM_BUILD_ROOT/etc
mkdir -p $RPM_BUILD_ROOT/usr/man/man4
install -m 644 mailcap.4 $RPM_BUILD_ROOT/usr/man/man4

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%config /etc/mailcap
%config /etc/mailcap.vga
%config /etc/mime.types
/usr/man/man4/mailcap.4

%changelog
* Thu Jun 16 1999 Bill Nottingham <notting@redhat.com>
- rpm files are RPM files. :)

* Sat May 15 1999 Jeff Johnson <jbj@redhat.com>
- fix typo in pdf entry (#2618).

* Mon Mar 29 1999 Bill Nottingham <notting@redhat.com>
- comment out play

* Fri Mar 19 1999 Preston Brown <pbrown@redhat.com>
- updated mime type for images from xv to ee
- cleaned up for our new version of the package which is in CVS

* Sat Mar 13 1999 Matt Wilson <msw@redhat.com>
- updated mime.types

* Fri Feb 12 1999 Bill Nottingham <notting@redhat.com>
- comment out backticked %variables to work around security problems

* Wed Jan 06 1999 Cristian Gafton <gafton@redhat.com>
- glibc version 2.1

* Mon Sep 21 1998 Bill Nottingham <notting@redhat.com>
- we don't ship tracker, use mikmod instead

* Wed Jul 29 1998 Jeff Johnson <jbj@redhat.com>
- build root

* Mon Apr 27 1998 Prospector System <bugs@redhat.com>
- translations modified for de, fr, tr

* Tue Oct 21 1997 Donnie Barnes <djb@redhat.com>
- added /etc/mime.types from mutt to this package to make it universal

* Tue Sep 09 1997 Erik Troan <ewt@redhat.com>
- made a noarch package
