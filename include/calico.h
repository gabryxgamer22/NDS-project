#ifndef CALICO_H
#define CALICO_H

/*
 * Compatibility shim for older or incomplete devkitPro/libnds installations.
 * Some versions of nds.h reference calico.h even though the header is not
 * actually required for a minimal homebrew project.
 *
 * This empty implementation prevents the build from failing while keeping the
 * project portable across environments that do not ship the optional header.
 */

#endif /* CALICO_H */
