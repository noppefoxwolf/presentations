decode h264 with swift

h264 → decoder → sampleBuffer → AVSampleBufferDisplayLayer

良いこと
キャプチャが取れる
AVAssetsにバグがあっても大丈夫


https://mntone.hateblo.jp/entry/2013/09/03/180431

最初の4byteを見て00 00 00 01であれば次のstartCodeまで取得する
0001NALU/0001NALU
vimでバイナリ見た感じ春

NALの頭にnalTypeがある
101Pの表はる

0x05 IDR frame
映像の実態

下記の概要

VTDecompressionSessionでセッションを作る

CMBlockBufferCreateWithMemoryBlockでBlockBufferを作る
CMSampleBufferCreateReadyで空のsampleBufferを生成する（この時にdescを入れる）
descの謎変換する

DecomplessSessionのコールバックでimageBufferを取得できる！

これらを描画していけばOK
decomplessSessionが無くてもAVSampleBufferDisplayLayerに未デコードのbufferを渡しても良い。



