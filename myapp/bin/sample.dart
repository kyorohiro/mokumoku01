import 'package:simple_cluster/simple_cluster.dart';

main( ){
  print("Hello, World!!");
  var colors = [
    [20.0, 20.0, 80.0],
    [22.0, 22.0, 90.0],
    [250.0, 255.0, 253.0],
    [100.0, 54.0, 255.0]
  ];


  Hierarchical hierarchical = Hierarchical(
    minCluster: 2, //stop at 2 cluster
    linkage: LINKAGE.SINGLE
  );

  var clusterList = hierarchical.run(colors);

  print("===== 1 =====");
  print("Clusters output");
  print(clusterList);//or hierarchical.cluster
  print("Noise");
  print(hierarchical.noise);
  print("Cluster label for points");
  print(hierarchical.label);
}