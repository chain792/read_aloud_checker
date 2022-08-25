class AwsPollyService
  # テキストを音声に変換しS3に保存する
  def self.call(text, voice_id, path)
    resp = Polly.synthesize_speech({
      engine: "neural",
      language_code: "en-US",
      output_format: "mp3",
      text: "Text",
      voice_id: voice_id
    })
    speech_name = SecureRandom.urlsafe_base64
    PUBLIC_BUCKET.put_object(
      acl: 'private',
      body: resp.audio_stream.read,
      key: "public/#{ENV['RAILS_ENV']}/uploads/#{path}/#{speech_name}.mp3"
    )
    speech_name
  end
end