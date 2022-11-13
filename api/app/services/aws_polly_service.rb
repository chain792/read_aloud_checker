class AwsPollyService
  # テキストを音声に変換しS3に保存する
  def self.call(text, voice_id, path)
    if Rails.env.test?
      # if true
      "test_#{voice_id}_#{path}"
    else
      resp = Polly.synthesize_speech({
        engine: "neural",
        language_code: "en-US",
        output_format: "mp3",
        text: text,
        voice_id: voice_id,
      })
      speech_name = SecureRandom.urlsafe_base64
      PUBLIC_BUCKET.put_object(
        acl: 'private',
        body: resp.audio_stream.read,
        key: "public/#{ENV.fetch('RAILS_ENV', nil)}/uploads/#{path}/#{speech_name}.mp3",
      )
      speech_name
    end
  end
end
