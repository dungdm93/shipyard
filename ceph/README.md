<img src="https://ceph.io/wp-content/uploads/2016/07/Ceph_Logo_Stacked_RGB_120411_fa.png"
    alt="rook logo"
    align="right" height="128"/>

`ceph`
======
Ceph is an open-source software storage platform, uniquely delivers object, block, and file storage in one unified system.

## 1. Architecture
![Ceph Architecture](https://docs.ceph.com/docs/master/_images/stack.png)

### 1.1 Features
* RADOS backend
    * [x] `FileStore` *Obsoleted*
    * [x] `BlueStore` Production (Since Jewel)
    * [ ] `Seastore` Early states
* OSD:
    * [x] [`msgr2` protocol](https://docs.ceph.com/docs/master/dev/msgr2/)
    * [ ] `DPDK`/`RDMA` Async Messenger
        * [ref](https://docs.ceph.com/docs/master/rados/configuration/ms-ref/#async-messenger-options)
    * [ ] `crimson-osd` (base on [`seastar`](http://seastar.io/) C++ framework)
        * [YouTube](https://youtu.be/FuFmMB9rbRA)
        * [Status](https://github.com/ceph/ceph-notes/blob/master/crimson/status.rst)
* MGR:
    * [x] Manager Dashboard (Sine Nautilus)
        * [YouTube](https://youtu.be/eBxyULifdxA)
* Ceph RGW
    * [ ] `Civetweb` HTTP Frontend (Since Firefly, Obsoleted now)
    * [x] `Beast` HTTP Frontend (Since Mimic)
    * [ ] Project Zipper
        * [Mail list](https://www.spinics.net/lists/ceph-devel/msg45153.html)
* Gateways
    * [x] NFS Gateway using [Ganesha](http://nfs-ganesha.github.io/)
    * [ ] SMB Gateway using [Samba](https://www.samba.org/)
    * [x] iSCSI Gateway
* Orchestrator module
    * [x] cephadm
    * [x] Rook

### 1.2 References
* What's new in Ceph *Nautilus*: [Event](https://archive.fosdem.org/2019/schedule/event/ceph_project_status_update/)
* What's new in Ceph *Octopus*: [Slide](https://www.msi.umn.edu/sites/default/files/doug.pdf)
