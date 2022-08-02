import ISpeechRecognition from './i-speech-recognition';

// ISpeechRecognitionConstructorはコンストラクト可能でコンストラクトするとISpeechRecognitionの型定義を持つ
interface ISpeechRecognitionConstructor {
  new (): ISpeechRecognition;
}

//windowにISpeechRecognitionConstructorを定義にもつSpeechRecognitionとwebkitSpeechRecognitionを追加
interface IWindow extends Window {
  SpeechRecognition: ISpeechRecognitionConstructor;
  webkitSpeechRecognition: ISpeechRecognitionConstructor;
}

declare const window: IWindow;

export default window