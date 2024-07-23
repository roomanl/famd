import 'dart:async';

// import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// 连接状态枚举
enum ConnectStatusEnum {
  //已连接
  connect,
  //连接中
  connecting,
  //已关闭
  close,
  //关闭中
  closing
}

/// 接收到消息后的回调
typedef ListenMessageCallback = void Function(String msg);

/// 错误回调
typedef ErrorCallback = void Function(Exception error);

/// WebSocket管理类
class WebSocketManager {
  /// 连接状态，默认为关闭
  ConnectStatusEnum _connectStatus = ConnectStatusEnum.close;

  /// WebSocket通道
  WebSocketChannel? _webSocketChannel;

  /// WebSocket通道的流
  Stream<dynamic>? _webSocketChannelStream;

  /// WebSocket状态的流控制器
  final StreamController<ConnectStatusEnum> _socketStatusController =
      StreamController<ConnectStatusEnum>();

  /// 连接状态的流
  Stream<ConnectStatusEnum>? _socketStatusStream;

  /// 获取WebSocket消息的流
  Stream<dynamic> getWebSocketChannelStream() {
    //只赋值一次
    _webSocketChannelStream ??= _webSocketChannel!.stream.asBroadcastStream();
    return _webSocketChannelStream!;
  }

  WebSocketChannel getWebSocketChannel() {
    return _webSocketChannel!;
  }

  /// 获取连接状态的流
  Stream<ConnectStatusEnum> getSocketStatusStream() {
    //只赋值一次
    _socketStatusStream ??= _socketStatusController.stream.asBroadcastStream();
    return _socketStatusStream!;
  }

  /// 发起连接，Url实例："ws://echo.websocket.org";
  Future<bool> connect(String url) async {
    if (_connectStatus == ConnectStatusEnum.connect) {
      //已连接，不需要处理
      return true;
    } else if (_connectStatus == ConnectStatusEnum.close) {
      //未连接，发起连接
      _connectStatus = ConnectStatusEnum.connecting;
      _socketStatusController.add(ConnectStatusEnum.connecting);
      var connectUrl = Uri.parse(url);
      _webSocketChannel = IOWebSocketChannel.connect(connectUrl);
      _connectStatus = ConnectStatusEnum.connect;
      _socketStatusController.add(ConnectStatusEnum.connect);
      return true;
    } else {
      return false;
    }
  }

  /// 关闭连接
  Future disconnect() async {
    if (_connectStatus == ConnectStatusEnum.connect) {
      _connectStatus = ConnectStatusEnum.closing;
      if (!_socketStatusController.isClosed) {
        _socketStatusController.add(ConnectStatusEnum.closing);
      }
      await _webSocketChannel?.sink.close(3000, "主动关闭");
      _connectStatus = ConnectStatusEnum.close;
      if (!_socketStatusController.isClosed) {
        _socketStatusController.add(ConnectStatusEnum.close);
      }
    }
  }

  /// 重连
  void reconnect(String url) async {
    await disconnect();
    await connect(url);
  }

  /// 监听消息
  void listen(ListenMessageCallback messageCallback, {ErrorCallback? onError}) {
    getWebSocketChannelStream().listen((message) {
      messageCallback.call(message);
    }, onError: (error) {
      //连接异常
      _connectStatus = ConnectStatusEnum.close;
      _socketStatusController.add(ConnectStatusEnum.close);
      if (onError != null) {
        onError.call(error);
      }
    });
  }

  /// 发送消息
  bool sendMsg(Object text) {
    if (_connectStatus == ConnectStatusEnum.connect) {
      _webSocketChannel?.sink.add(text);
      return true;
    }
    return false;
  }

  /// 获取当前连接状态
  ConnectStatusEnum getCurrentStatus() {
    if (_connectStatus == ConnectStatusEnum.connect) {
      return ConnectStatusEnum.connect;
    } else if (_connectStatus == ConnectStatusEnum.connecting) {
      return ConnectStatusEnum.connecting;
    } else if (_connectStatus == ConnectStatusEnum.close) {
      return ConnectStatusEnum.close;
    } else if (_connectStatus == ConnectStatusEnum.closing) {
      return ConnectStatusEnum.closing;
    }
    return ConnectStatusEnum.closing;
  }

  /// 销毁通道
  void dispose() {
    //断开连接
    disconnect();
    //关闭连接状态的流
    _socketStatusController.close();
  }
}
