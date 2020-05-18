<img src="https://ceph.io/wp-content/uploads/2016/07/Ceph_Logo_Stacked_RGB_120411_fa.png"
    alt="rook logo"
    align="right" height="128"/>

`ceph`
======
Ceph is an open-source software storage platform, uniquely delivers object, block, and file storage in one unified system.

## 1. Architecture
![Ceph Architecture](https://docs.ceph.com/docs/master/_images/stack.png)

### 1.1 Features
* [x] `BlueStore` RADOS backend (Since Jewel - 10.2)
* [x] `Beast` Ceph RGW HTTP Frontend (Since Mimic 13.2)
* [x] [`msgr2` protocol](https://docs.ceph.com/docs/master/dev/msgr2/)
* [ ] `DPDK`/`RDMA` Async Messenger
    * [ref](https://docs.ceph.com/docs/master/rados/configuration/ms-ref/#async-messenger-options)
* [ ] `crimson-osd` (base on [`seastar`](http://seastar.io/) C++ framework)
    * [YouTube](https://youtu.be/FuFmMB9rbRA)
* [ ] RGW project Zipper
    * [Mail list](https://www.spinics.net/lists/ceph-devel/msg45153.html)
* [x] Manager Dashboard (Sine Nautilus - 14.2)
    * [YouTube](https://youtu.be/eBxyULifdxA)
* [x] NFS Gateway using [Ganesha](http://nfs-ganesha.github.io/)
* [ ] SMB Gateway using [Samba](https://www.samba.org/)
* [x] iSCSI Gateway

### 1.2 References
* What's new in Ceph *Nautilus*: [Event](https://archive.fosdem.org/2019/schedule/event/ceph_project_status_update/)
* What's new in Ceph *Octopus*: [Slide](https://www.msi.umn.edu/sites/default/files/doug.pdf)
