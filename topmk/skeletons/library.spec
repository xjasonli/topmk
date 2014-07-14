%define debug_package %{nil}
%define __os_install_post %{nil}
license: Commercial
vendor: None
group: Development/Libraries
buildroot: %{_tmppath}/%{name}-%{version}-%{release}-%(%{__id_u} -n)

# Package information
name:    %{name}
version: %{version}
summary: %{summary}
release: 1%{?dist}

# Package source tar. Uncomment this line if source tarball is used
#source: %{name}-%{version}.tar.gz

# Required package list duraing package building
#buildrequires: 

# Required package list
#requires: 

%description
%{summary}

%package devel
group: Development/Libraries
summary: %{summary} development files
requires: %{name} = %{version}-%{release}

%description devel
%{summary} development files

# Prepare section. Uncomment this section if source tarball is used
#%prep
#%setup -q

%build
# cd %{root}
# make %{?_smp_mflags}

%install
rm -rf %{buildroot}
# cd %{root}
# make install DESTDIR=%{buildroot}

%files
%defattr(-,root,root)
# %dir %{_prefix}/lib
# %{_prefix}/lib/*.so.*

%files devel
%defattr(-,root,root)
# %dir %{_prefix}/include
# %dir %{_prefix}/lib
# %{_prefix}/include
# %{_prefix}/lib/*.so

%pre
if [ $1 -eq 1 ]; then
: # Installing
else
: # Replacing an exising version
fi

%post
if [ $1 -eq 1 ]; then
: # Installing
else
: # Replacing an existing version
fi

%preun
if [ $1 -eq 0 ]; then
: # Removing
else
: # Replacing by another version, 
fi

%postun
if [ $1 -eq 0 ]; then
: # Removing
else
: # Replacing by another version, 
fi

%clean
rm -rf %{buildroot}

%changelog
